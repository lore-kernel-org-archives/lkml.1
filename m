Return-Path: <linux-kernel-owner+w=401wt.eu-S1753034AbXBJJMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbXBJJMH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 04:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbXBJJMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 04:12:07 -0500
Received: from web36703.mail.mud.yahoo.com ([209.191.85.37]:30687 "HELO
	web36703.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753034AbXBJJMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 04:12:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=NqdL/eyawGozHqN4s56K78h7yWmPaccXrm+LPso/+JHVF+hSTCojjrzMV0eboN4j3RbHixPqXBGx4reRVaNxbE5ojcid3z2hXPOTteJgplUMQKQqog/5w1lXaviDm7Gh7oMVfAECzDzfSC44SGCyTThBnzZkkQmacsZCRKao+Xk=;
X-YMail-OSG: pgWW.c8VM1n_TaOwptlEY.vG0n3vE8IAmTtZcmxn479q2NdArvbDOMU_Z0UarhnhOfBKl3HQ25r5Lld7MqFTaCx6efbumDq9dj_FrpQKbruf7yKvnV4fHxnt.kq0RR_CmyXHal0qbSQcBsnrcQeMTiGSNrxbYfQuDg--
Date: Sat, 10 Feb 2007 01:12:02 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Recent and not-so problems with tifm_sd driver - one more
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45CCC72A.8020904@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <113489.35158.qm@web36703.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One more problem (you may already know about it) - I was contacted by somebody from the hald
project and indeed I can confirm that on 2.6.20 kernel hald fails to take action on card
insertion. I can't see anything in my code so this may be a general mmc problem.
The problem is described here:
http://lists.freedesktop.org/archives/hal/2007-January/006960.html



 
____________________________________________________________________________________
Food fight? Enjoy some healthy debate 
in the Yahoo! Answers Food & Drink Q&A.
http://answers.yahoo.com/dir/?link=list&sid=396545367
