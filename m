Return-Path: <linux-kernel-owner+w=401wt.eu-S1763531AbYDQPn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763531AbYDQPn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765736AbYDQPnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:43:10 -0400
Received: from mout0.freenet.de ([195.4.92.90]:33331 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762448AbYDQPnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:43:08 -0400
Message-ID: <48076FD6.60505@de.ibm.com>
Date: Thu, 17 Apr 2008 17:42:14 +0200
From: Carsten Otte <cotte@de.ibm.com>
Reply-To: carsteno@de.ibm.com
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH=2CVor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Martin_Jetter=2CGe?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher=2CSitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen=2CRegistergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/45] KVM: s390: API documentation
References: <1208423450-29415-1-git-send-email-avi@qumranet.com> <1208423450-29415-14-git-send-email-avi@qumranet.com> <20080417081106.aab87b1a.randy.dunlap@oracle.com>
In-Reply-To: <20080417081106.aab87b1a.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Warning: de.ibm.com is listed at abuse.rfc-ignorant.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Please use "CPU" consistently throughout the file (i.e., not "cpu").
Thanks, will fix that with a patch that'll go on top.
