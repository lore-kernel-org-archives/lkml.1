Return-Path: <linux-kernel-owner+w=401wt.eu-S932249AbXGLBHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249AbXGLBHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 21:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759069AbXGLBHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 21:07:33 -0400
Received: from smtp-out.google.com ([216.239.45.13]:9948 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758466AbXGLBHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 21:07:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=Bh0jpRKh5B69tB9xBrlG3f12nmAh2gfBB0Vi7Ud51U/K2dbJDJXpLtk1R8XTbejHK
	QjYxItI5+DrdRjI/JqEHA==
Message-ID: <46957EC6.7080006@google.com>
Date: Wed, 11 Jul 2007 18:07:18 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@google.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
Subject: Re: [RFC 1/7] cpuset write dirty map
References: <465FB6CF.4090801@google.com> <Pine.LNX.4.64.0706041138410.24412@schroedinger.engr.sgi.com> <46646A33.6090107@google.com> <Pine.LNX.4.64.0706041250440.25535@schroedinger.engr.sgi.com> <468023CA.2090401@google.com> <Pine.LNX.4.64.0706261216110.20282@schroedinger.engr.sgi.com> <46952D0A.1090304@google.com> <Pine.LNX.4.64.0707111311040.18429@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0707111311040.18429@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> 
> This may be a leftover from earlier times when the logic was different in 
> throttle vm writeout? 

	Sorry -- my merge error when looking at an earlier kernel, no issue
with mainline  or -mm.
	-- Ethan
