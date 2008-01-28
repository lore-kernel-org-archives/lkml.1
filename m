Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbYA1QUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbYA1QUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYA1QT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:19:58 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:40753 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbYA1QT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:19:56 -0500
Date: Mon, 28 Jan 2008 08:17:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Paul Jackson <pj@sgi.com>
Cc: michael-lists@free-electrons.com, rob@landley.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Documentation: mention email-clients.txt in
 SubmittingPatches
Message-Id: <20080128081759.4efa8544.randy.dunlap@oracle.com>
In-Reply-To: <20080128095245.f8306466.pj@sgi.com>
References: <200801181120.03168.michael-lists@free-electrons.com>
	<20080118083415.07c37f2a.randy.dunlap@oracle.com>
	<20080128095245.f8306466.pj@sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008 09:52:45 -0600 Paul Jackson wrote:

> Randy -- any idea why the Documentation/email-clients.txt file states:
> 
>     Sylpheed (GUI)
>      ...
>     - Not good for IMAP.                                                                                                              
> 
> I've been happily using Sylpheed with IMAP ... I wonder what I'm missing ;)

Hi Paul,

I think that this is based on filtering to folders.
Does Sylpheed IMAP do filtering for you?

It does not according to the Sylpheed FAQ, but the FAQ is
extremely out of date.

The doc file can also be amended with whatever we decide here.

Thanks,
---
~Randy
