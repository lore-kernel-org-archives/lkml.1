Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302Ab0ADJOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0ADJOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 04:14:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881Ab0ADJOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 04:14:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55334 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab0ADJOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 04:14:52 -0500
Message-ID: <4B41B186.2090401@suse.cz>
Date: Mon, 04 Jan 2010 10:14:46 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Ben Dooks <ben@fluff.org>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: modules.order and modules.builting files created
References: <20100104045756.GA13621@fluff.org.uk>
In-Reply-To: <20100104045756.GA13621@fluff.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4.1.2010 05:57, Ben Dooks wrote:
> The modules.order and modules.builtin files are ending up clogging
> up 'git status' enquiries after building a recent kernel. Is there
> any reason these can't be hidden?

There is

*.order
modules.builtin

in the top-level .gitignore file.

Michal
