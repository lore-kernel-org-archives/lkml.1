Return-Path: <linux-kernel-owner+w=401wt.eu-S1760204AbYG1RPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204AbYG1RPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbYG1RPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:15:44 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:63306 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004AbYG1RPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:15:44 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: 463 kernel developers missing!
Date: Mon, 28 Jul 2008 19:15:32 +0200
User-Agent: KMail/1.9.9
Cc: "Adrian Bunk" <bunk@kernel.org>, lkml <linux-kernel@vger.kernel.org>
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com> <20080728153546.GD30612@cs181140183.pp.htv.fi> <9e4733910807280845y7e07486n84794a6e74cb59c2@mail.gmail.com>
In-Reply-To: <9e4733910807280845y7e07486n84794a6e74cb59c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281915.32857.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 28. Juli 2008 schrieb Jon Smirl:
> > You count merges as patches.
> 
> I just used the output from git shortlog, is there a better way?

git-shortlog --no-merges

You can also avoid the grepping:

git-shortlog -n -s --no-merges
