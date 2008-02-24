Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbYBXO4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbYBXO4x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 09:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYBXO4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 09:56:45 -0500
Received: from khc.piap.pl ([195.187.100.11]:53046 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbYBXO4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 09:56:44 -0500
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Tabs, spaces, indent and 80 character lines
References: <47C0BEE7.4040409@student.ltu.se>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 24 Feb 2008 15:56:42 +0100
In-Reply-To: <47C0BEE7.4040409@student.ltu.se> (Richard Knutsson's message of "Sun\, 24 Feb 2008 01\:48\:39 +0100")
Message-ID: <m3ejb2bdxx.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Knutsson <ricknu-0@student.ltu.se> writes:

> Why hinder a developer who prefer
> 2, 4, 6 or any other != 8 width?

I guess we could use tabs only at the line start, for indentation
only. Rather hard to implement, most text editors can't do that yet.

> By only using tabs as indents, and
> changing the CodeStyle to be something like "maximum 80
> characters-wide lines, with a tab-setting of 8 spaces",

This changes nothing.

> that is
> possible + easier to write code-checkers [2].

I doubt it.

> Or are we really that concerned about the disk-space? ;)

Unpacked sources will be much bigger with not tabs, sure.
-- 
Krzysztof Halasa
