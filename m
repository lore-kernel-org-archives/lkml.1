Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbXJVK5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbXJVK5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 06:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbXJVK5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 06:57:39 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58561 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845AbXJVK5i (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 06:57:38 -0400
Message-ID: <471C821A.8020500@de.ibm.com>
Date: Mon, 22 Oct 2007 12:57:30 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: carsteno@linux.vnet.ibm.com,
       "kvm-devel@lists.sourceforge.net" <kvm-devel@lists.sourceforge.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] severe bug in 2.6.23+ kvm.git
References: <47189371.7080104@de.ibm.com> <4718C9A1.3010703@qumranet.com>
In-Reply-To: <4718C9A1.3010703@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> kvm.git is actually 2.6.24-rc, pulled from -linus at a random point in
> time, so it's not at all surprising if something is broken.
Right. We have a backup now, so next time we'll be ok ;-). Would you 
please pull from Linus again to get the fix into kvm.git so that we 
can use your tree on that machine again?

thanks,
Carsten
