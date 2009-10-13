Return-Path: <linux-kernel-owner+w=401wt.eu-S933730AbZJMOvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbZJMOvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 10:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759852AbZJMOvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 10:51:03 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:34031 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760051AbZJMOvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 10:51:01 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pavel Emelyanov <xemul@openvz.org>
Cc: vatsa@in.ibm.com, Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v2 PATCH 0/8] CFS Hard limits - v2
In-Reply-To: Your message of "Tue, 13 Oct 2009 15:39:17 +0400."
             <4AD466E5.4010206@openvz.org>
From: Valdis.Kletnieks@vt.edu
References: <20090930124919.GA19951@in.ibm.com> <4AC35EDD.1080902@openvz.org> <20090930142537.GJ19951@in.ibm.com> <20090930143953.GA2014@in.ibm.com>
            <4AD466E5.4010206@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1255445366_3097P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 13 Oct 2009 10:49:26 -0400
Message-ID: <4562.1255445366@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4AD49377.023E,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1255445366_3097P
Content-Type: text/plain; charset=us-ascii

On Tue, 13 Oct 2009 15:39:17 +0400, Pavel Emelyanov said:

> 3) virtual cpu power in M/GHz - I don't agree with Balbir that
>    this is difficult for administrator. This is better than two
>    numbers and better that the percentage, since the amount of
>    cpu time got by a container will not change after migrating to
>    a more powerful CPU.

2Gz worth of throughput on an old Xeon is probably not the same as
half of a 4Gz i7.

--==_Exmh_1255445366_3097P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK1JN2cC3lWbTT17ARAtIQAJ9xU3WzoqTLQyphm1RjQq4qM/7WvgCfcyQe
+SG8IvdBESjJJrOvOTyfIvk=
=FTqX
-----END PGP SIGNATURE-----

--==_Exmh_1255445366_3097P--

