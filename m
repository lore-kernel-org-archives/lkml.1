Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbZIYMsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbZIYMsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 08:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbZIYMsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 08:48:16 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:65514 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612AbZIYMsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 08:48:15 -0400
From: Frans Pop <elendil@planet.nl>
To: Alexander Huemer <alexander.huemer@sbg.ac.at>
Subject: Re: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
Date: Fri, 25 Sep 2009 14:48:16 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, stable@kernel.org
References: <4ABBB8C2.2080901@sbg.ac.at> <200909251424.25334.elendil@planet.nl> <4ABCB732.9050609@sbg.ac.at>
In-Reply-To: <4ABCB732.9050609@sbg.ac.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909251448.17671.elendil@planet.nl>
X-OriginalArrivalTime: 25 Sep 2009 12:48:17.0794 (UTC) FILETIME=[745FA620:01CA3DDE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 September 2009, Alexander Huemer wrote:
> > So with the revert already in mainline for .32, the only thing left is
> > for that to get included in stable updates for .30 and .31.
>
> please see the last comment in [1].
> can i do anything else to help ?

> [1] http://bugzilla.kernel.org/show_bug.cgi?id=14124

Yes, adding that comment was excellent. I also added the relevant people
in the CC of my previous mail, so it should get taken care of now. Unless 
they have additional questions no further action from you should be 
needed.
