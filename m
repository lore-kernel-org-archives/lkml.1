Return-Path: <linux-kernel-owner+w=401wt.eu-S933877AbXJSL4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877AbXJSL4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 07:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755599AbXJSL4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 07:56:05 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33608 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbXJSL4E (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 07:56:04 -0400
Message-ID: <47189B47.6070107@de.ibm.com>
Date: Fri, 19 Oct 2007 13:55:51 +0200
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
CC: "kvm-devel@lists.sourceforge.net" <kvm-devel@lists.sourceforge.net>,
       Linux-kernel@vger.kernel.org
Subject: Re: severe bug in 2.6.23+ kvm.git
References: <47189371.7080104@de.ibm.com>
In-Reply-To: <47189371.7080104@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carsten Otte wrote:
> 2.6.23 is  broken, 2.6.23-rc8 works for us.
Actually, the working version was 2.6.23-rc6, git-head of kvm.git as 
of October 11.
