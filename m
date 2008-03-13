Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYCMQJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYCMQJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYCMQJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:09:06 -0400
Received: from gw.goop.org ([64.81.55.164]:55632 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbYCMQJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:09:05 -0400
Message-ID: <47D95134.6030503@goop.org>
Date: Thu, 13 Mar 2008 09:07:16 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: schwidefsky@de.ibm.com
CC: Jeremy Fitzhardinge <jeremy@goop.org>, akpm@osdl.org,
       linux-s390@vger.kernel.org, frankeh@watson.ibm.com,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, Anthony Liguori <anthony@codemonkey.ws>,
       hugh@veritas.com
Subject: Re: [patch 6/6] Guest page hinting: s390 support.
References: <20080312132132.520833247@de.ibm.com>	<20080312132704.474209626@de.ibm.com>	<47D802A2.1030406@goop.org>	<1205339285.8851.13.camel@localhost>	<47D8085E.9030701@goop.org>	<1205341164.8851.44.camel@localhost>	<47D81771.5070400@goop.org>	<47D8373C.40105@codemonkey.ws>	<47D840E3.5090902@goop.org>	<47D8436F.9080901@codemonkey.ws>  <47D84CEB.6050300@goop.org> <1205401508.26537.37.camel@localhost>
In-Reply-To: <1205401508.26537.37.camel@localhost>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> Vz->Vr cannot happen. This would be a bug in the host.
>   

Does that mean that Vz is effectively identical to Uz?

    J
