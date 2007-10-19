Return-Path: <linux-kernel-owner+w=401wt.eu-S1763833AbXJSLtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763833AbXJSLtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 07:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754009AbXJSLtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 07:49:39 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46742 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbXJSLti (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 07:49:38 -0400
Message-ID: <471899CA.8060206@de.ibm.com>
Date: Fri, 19 Oct 2007 13:49:30 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: carsteno@de.ibm.com, Aurelien Jarno <aurelien@aurel32.net>,
       "kvm-devel@lists.sourceforge.net" <kvm-devel@lists.sourceforge.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] severe bug in 2.6.23+ kvm.git
References: <47189371.7080104@de.ibm.com> <47189585.5010901@aurel32.net> <47189706.1040809@de.ibm.com> <4718982D.4020500@bull.net>
In-Reply-To: <4718982D.4020500@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> How do you know the problem has been introduced by kvm ?
I don't. In fact I think it has not been introduced by kvm. All I 
stated, is that we experienced the problem when running the kvm.git 
kernel after the 2.6.23 update that has not been present in the 
kvm.git -rc8 as of last thursday.
