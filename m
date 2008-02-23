Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbYBWEhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbYBWEhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 23:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbYBWEgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 23:36:53 -0500
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:36805 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbYBWEgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 23:36:51 -0500
Message-ID: <47BFA37F.10806@keyaccess.nl>
Date: Sat, 23 Feb 2008 05:39:27 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Chase Venters <chase.venters@clientec.com>
CC: linux-kernel@vger.kernel.org, git@vger.kernel.org
Subject: Re: Question about your git habits
References: <200802221837.37680.chase.venters@clientec.com>
In-Reply-To: <200802221837.37680.chase.venters@clientec.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23-02-08 01:37, Chase Venters wrote:

> Or perhaps you create a temporary topical branch for each thing you are 
> working on, and commit arbitrary changes then checkout another branch
> when you need to change gears, finally --squashing the intermediate
> commits when a particular piece of work is done?

No very specific advice to give but this is what I do and then pull all 
(compilable) topic branches into a "local" branch for complation. Just 
wanted to remark that a definite downside is that switching branches a lot 
also touches the tree a lot and hence tends to trigger quite unwelcome 
amounts of recompiles. Using ccache would proably be effective in this 
situation but I keep neglecting to check it out...

Rene
