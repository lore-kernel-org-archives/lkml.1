Return-Path: <linux-kernel-owner+w=401wt.eu-S934469AbZAPUwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934469AbZAPUwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 15:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbZAPUwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 15:52:06 -0500
Received: from mail.lang.hm ([64.81.33.126]:50307 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725AbZAPUwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 15:52:05 -0500
Date: Fri, 16 Jan 2009 13:55:11 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Prateek Donni <prateek.donni@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: RAID v/s Normal redundant files
In-Reply-To: <a80c86b70901160201t7d8e6fal28592129f9407d68@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0901161353580.18009@asgard.lang.hm>
References: <a80c86b70901160201t7d8e6fal28592129f9407d68@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009, Prateek Donni wrote:

> Can normal redundant files perform better than RAID configuration.

sometimes, it depends on how you have them setup and where the bottlenecks 
are in your system.

note that RAID is also supposed to do integrity checking on reads that you 
would have to do in userspace with redundant files.
