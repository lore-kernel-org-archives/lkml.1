Return-Path: <linux-kernel-owner+w=401wt.eu-S1760359AbZAHO24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760359AbZAHO24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:28:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZAHO2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:28:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39555 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbZAHO2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:28:48 -0500
Date: Thu, 8 Jan 2009 09:28:46 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Robert Richter <robert.richter@amd.com>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [PATCH] ring_buffer: fix ring_buffer_event_length()
In-Reply-To: <20090108115958.GB1539@elte.hu>
Message-ID: <alpine.DEB.1.10.0901080927340.22642@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901072356480.14345@gandalf.stny.rr.com> <20090108115958.GB1539@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 8 Jan 2009, Ingo Molnar wrote:
> 
> That is a pretty useless duplication of the subject line, so i dropped it. 
> When the subject line explains the practical impact already, there's no 
> need to add the impact line.

Actually, Frederic and I had a discussion about a duplicate Impact line. 
Perhaps someone is searching the git log on "Impact:" looking for all 
fixes. Perhaps just a simple:

Impact: fix

would be sufficient?

-- Steve

