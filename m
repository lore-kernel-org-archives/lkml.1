Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbZERP7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbZERP7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZERP7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:59:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43385 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbZERP7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:59:35 -0400
Message-ID: <4A1185B9.8050301@redhat.com>
Date: Mon, 18 May 2009 10:58:49 -0500
From: David Smith <dsmith@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jon Masters <jonathan@jonmasters.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [tracing] ring_buffer question
References: <1242594505.6327.3.camel@localhost.localdomain> <1242607182.6327.8.camel@localhost.localdomain>
In-Reply-To: <1242607182.6327.8.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters wrote:
> [thinking out loud] Does the global disable stuff also disable other
> non-tracing ring buffers?

I believe it does.  If I'm correct, I think it would be a good idea to
make that an ftrace-disable feature, not a general ring buffer disable
feature.

-- 
David Smith
dsmith@redhat.com
Red Hat
http://www.redhat.com
256.217.0141 (direct)
256.837.0057 (fax)
