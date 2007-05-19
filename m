Return-Path: <linux-kernel-owner+w=401wt.eu-S1761121AbXESKMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761121AbXESKMn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 06:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbXESKMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 06:12:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:47308 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754767AbXESKMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 06:12:36 -0400
X-Authenticated: #283898
X-Provags-ID: V01U2FsdGVkX1/888AxGbj8m5HQa3Zvdl9znUyewb/JT2dgl8PmcS
	wY6dTFnqpw8yMR
Subject: VFS design question
From: Tobias Pflug <tobias.pflug@gmx.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 19 May 2007 12:14:15 +0200
Message-Id: <1179569656.6558.349.camel@toontown>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A note in front: I realize that my question is rather broad and a bit
vague, sorry for that :)

The VFS is a great solution to transparently operate on different file
systems by designating an interface for file systems that separates 
file system specific code from higher levels. 

Doesn't however this very feature also represent a limiting factor in
some way? Surely you can map pretty much anything to the Common File
System model, but is or has the VFS interface design been limiting
in any way in contemporary file system design ? 

thanks for your time.
regards,
Tobi

PS: please CC I am not subscribed.thanks

