Return-Path: <linux-kernel-owner+w=401wt.eu-S1763672AbXJSNp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763672AbXJSNp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 09:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbXJSNpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 09:45:12 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:34600 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbXJSNpK (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 09:45:10 -0400
Message-ID: <4718B4DB.1000202@de.ibm.com>
Date: Fri, 19 Oct 2007 15:44:59 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: carsteno@de.ibm.com
CC: Mike Lampard <mike@secnet.net.au>, kvm-devel@lists.sourceforge.net,
       Aurelien Jarno <aurelien@aurel32.net>, Linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] severe bug in 2.6.23+ kvm.git
References: <47189371.7080104@de.ibm.com> <47189585.5010901@aurel32.net> <47189706.1040809@de.ibm.com> <200710192127.17584.mike@secnet.net.au> <4718A14B.4060008@de.ibm.com>
In-Reply-To: <4718A14B.4060008@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carsten Otte wrote:
> First thing we do, is figure whether or not 2.6.23.1 as released breaks 
> our system too. This way, we can either focus on differences between 
> Linus and Avi, or turn on the big red warning sign saying "regression".
Looks like 2.6.23.1 works fine on that box. We'll leave it running over
the weekend with "while true; do make; make clean; done".


