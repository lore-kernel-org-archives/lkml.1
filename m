Return-Path: <linux-kernel-owner+w=401wt.eu-S1761531AbXKHQCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761531AbXKHQCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 11:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759238AbXKHQCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 11:02:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756351AbXKHQCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 11:02:44 -0500
Message-ID: <4733323D.4070309@redhat.com>
Date: Thu, 08 Nov 2007 10:58:53 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Benny Halevy <bhalevy@panasas.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Coding Style: indenting with tabs vs. spaces
References: <4732E6BA.8060001@panasas.com>
In-Reply-To: <4732E6BA.8060001@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benny Halevy wrote:
> Greetings,
> 
> I would like to hear peoples opinion about the indentation convention
> described below that I personally found the most practical with
> several different editors.
> 
> The gist of it is that tabs should be used for nesting, not for decoration.
> Indent your code with as many tabs as your nesting level, where all statements
> will begin, and from there on use space characters.
> The rational behind it is to be tab-width agnostic so regardless of your
> tab expansion setup, the code will look correct and will make sense.
> 
> When you break a line and want the new line text to start below a specific point
> relative to the previous line (I consider that "decorating") then start the new
> line with the same number of tabs as the previous one and then just use space
> characters as their width is the same as any character in the previous line,
> (assuming fixed-width fonts of course).

I find it meaningful to indent extended lines one extra tab stop, but beyond 
that I agree it is just decoration.

	-- Chris
