Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab0BNVuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 16:50:12 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:36868 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab0BNVuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 16:50:11 -0500
MIME-Version: 1.0
In-Reply-To: <520f0cf11002141254y3f4536a9ta968dbaefbff58f7@mail.gmail.com>
References: <520f0cf11002110911t3f125649v73062e9851e2cfb3@mail.gmail.com>
	 <520f0cf11002140510w5c57d196n12f8036ea6085c52@mail.gmail.com>
	 <aca0ce8b1002140657l4f767635ob9b1611e4da2540b@mail.gmail.com>
	 <520f0cf11002141254y3f4536a9ta968dbaefbff58f7@mail.gmail.com>
Date: Sun, 14 Feb 2010 13:50:10 -0800
Message-ID: <aca0ce8b1002141350o16fcfe6bn658c0ca546b38da0@mail.gmail.com>
Subject: Re: [BUG]: Possibe recursive locking detected in sysfs
From: Eric Biederman <ebiederm@aristanetworks.com>
To: John Kacur <jkacur@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, are you referring to the patch-set that begins with
> "[PATCH 1/6] sysfs: Serialize updates to the vfs inode"?

Sorry no.

http://lkml.org/lkml/2010/2/11/329

Eric
