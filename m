Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbYG2F3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbYG2F3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYG2F3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:29:07 -0400
Received: from 1wt.eu ([62.212.114.60]:2002 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbYG2F3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:29:06 -0400
Date: Tue, 29 Jul 2008 07:19:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
Message-ID: <20080729051926.GI29189@1wt.eu>
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com> <9e4733910807280820v118b728fu1c0a8b8eb4c4fdaa@mail.gmail.com> <20080728153546.GD30612@cs181140183.pp.htv.fi> <9e4733910807280845y7e07486n84794a6e74cb59c2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910807280845y7e07486n84794a6e74cb59c2@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 11:45:29AM -0400, Jon Smirl wrote:
> On 7/28/08, Adrian Bunk <bunk@kernel.org> wrote:
> > You count merges as patches.
> 
> I just used the output from git shortlog, is there a better way?

git shortlog --no-merges

Willy

