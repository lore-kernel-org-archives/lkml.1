Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZFDWIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZFDWIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 18:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbZFDWIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 18:08:16 -0400
Received: from main.gmane.org ([80.91.229.2]:43914 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbZFDWIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 18:08:15 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: When does Linux drop UDP packets?
Date: Thu, 4 Jun 2009 23:03:23 +0100
Message-ID: <buslf6-j24.ln1@woodchuck.wormnet.eu>
References: <20090604145347.GA27692@miyuki>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: woodchuck.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-1-sparc64 (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Reh <sefi@s-e-f-i.de> wrote:
> 
> I have the following setting in which a client that resides on the same
> physical network as a server wants to receive any UDP packet that
> arrives on any of its interfaces sent by that server.
> 
Read up about multicasting, it will do what you want, does not depend on
the IP address of the destination workstation and will also cross 
subnets if you want it to.

It's dead easy to transmit and receive multicast traffic, broadcasting 
network traffic is so 1980's :)

> As I'm not yet subscribed to the list, please CC me directly.
> 
Have a look at GMANE for following large volumn mailing lists.

Cheers

-- 
Alexander Clouter
.sigmonster says: Familiarity breeds attempt.

