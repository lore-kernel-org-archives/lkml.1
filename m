Return-Path: <linux-kernel-owner+w=401wt.eu-S1751259AbZJTIKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259AbZJTIKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 04:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbZJTIKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 04:10:48 -0400
Received: from smtprelay08.ispgateway.de ([80.67.31.31]:48568 "EHLO
	smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbZJTIKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 04:10:47 -0400
Message-ID: <4ADD708A.6060906@ladisch.de>
Date: Tue, 20 Oct 2009 10:10:50 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Sam (Bren) & Dawn Colegrove" <samdec@bigpond.net.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Microphone on Logitech QuickCam Ultra Vision outputs
 clicks
References: <4ADC46DF.1090104@bigpond.net.au>
In-Reply-To: <4ADC46DF.1090104@bigpond.net.au>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam (Bren) & Dawn Colegrove wrote:
> with the microphone on the QuickCam Ultra Vision as input, the played
> back sound has clicks in it about every few seconds.

This is a known hardware problem with certain Logitech webcams.
Logitech's Windows driver works around this by filtering out the clicks;
they have not written a Linux driver that would do the same.


Best regards,
Clemens
