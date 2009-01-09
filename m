Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbZAIWYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbZAIWYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758952AbZAIWYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:24:14 -0500
Received: from twin.jikos.cz ([213.151.79.26]:56645 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285AbZAIWYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:24:11 -0500
Date: Fri, 9 Jan 2009 23:24:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jeremy Fitzhardinge <jeremy@xensource.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Does CONFIG_PARAVIRT imply usage of byte locks?
In-Reply-To: <alpine.LNX.1.10.0901092253240.5377@jikos.suse.cz>
Message-ID: <alpine.LRH.1.10.0901092323270.24105@twin.jikos.cz>
References: <alpine.LNX.1.10.0901092253240.5377@jikos.suse.cz>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009, Jiri Kosina wrote:

> It seems to me that paravirt_use_bytelocks() is a dead code that gets 
> never called, and the same applies to the implementations of write locks. 

	s/of write locks/of byte locks

of course, sorry.

-- 
Jiri Kosina
SUSE Labs
