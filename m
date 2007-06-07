Return-Path: <linux-kernel-owner+w=401wt.eu-S1760432AbXFGHEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760432AbXFGHEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 03:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbXFGHEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 03:04:00 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:59951 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbXFGHD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 03:03:59 -0400
Message-ID: <4667ADDA.2070202@de.ibm.com>
Date: Thu, 07 Jun 2007 09:03:54 +0200
From: Martin Peschke <mp3@de.ibm.com>
Organization: =?ISO-8859-1?Q?IBM_Deutschland_Entwicklung_GmbH_Vor?=
 =?ISO-8859-1?Q?sitzender_des_Aufsichtsrats=3A_Johann_Weihen_Ge?=
 =?ISO-8859-1?Q?sch=E4ftsf=FChrung=3A_Herbert_Kircher_Sitz_der_?=
 =?ISO-8859-1?Q?Gesellschaft=3A_B=F6blingen_Registergericht=3A_Amts?=
 =?ISO-8859-1?Q?gericht_Stuttgart=2C_HRB_243294?=
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: "Bill Huey (hui)" <billh@gnuppy.monkey.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, jbaron@redhat.com, rostedt@goodmis.org,
       linux-s390@vger.kernel.org
Subject: Re: [RFC] [Patch 4/4] lock contention tracking slimmed down
References: <1181165656.7133.23.camel@dix> <20070606230641.GA11592@elte.hu> <46674EA9.9090601@de.ibm.com> <20070607044017.GA3828@gnuppy.monkey.org>
In-Reply-To: <20070607044017.GA3828@gnuppy.monkey.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Huey (hui) wrote:
 > There are roughly about 400 locks in a normal kernel for a desktop. The
 > list is rather cumbersome anyways so, IMO, it really should be handled
 > by parsing tools, etc... There could be more properties attached to each
 > lock especially if you intend to get this to work on -rt which need more
 > things reported.

Adding stuff to an already wide table in a readable fashion is more difficult
than making a list longer.

Do mean I might submit this stuff for -rt?

