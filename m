Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbYAHSRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbYAHSRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbYAHSQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:16:58 -0500
Received: from main.gmane.org ([80.91.229.2]:59195 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbYAHSQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:16:58 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tuomo Valkonen <tuomov@iki.fi>
Subject: Re: The ext3 way of journalling
Date: Tue, 8 Jan 2008 18:16:49 +0000 (UTC)
Message-ID: <slrnfo7fgh.fne.tuomov@jolt.modeemi.cs.tut.fi>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <20080108164847.GA16462@skl-net.de> <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi> <1a9da18c0801081007q1ed8ce04x7a78e880ee5bcac7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: jolt.modeemi.cs.tut.fi
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-01-08, Masoud Sharbiani "مسعود شربیانی" <masouds@masoud.ir> wrote:
> It isn't a bug. It is a feature; 

To me, it seems to be a rather clear bug when the last-checked field 
contains an absurd value of years ago, on _all_ disks, and yet there's
no complaint of other superblock corruption.

> heh, the way I look at it, you either have the time, or money. 

Bullshit. There may be time to fix one thing, but there are a million
things broken in FOSS these days, and it's constantly getting worse.

-- 
Tuomo

