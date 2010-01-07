Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248Ab0AGHc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0AGHc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 02:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755915Ab0AGHc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 02:32:56 -0500
Received: from www84.your-server.de ([213.133.104.84]:38742 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab0AGHc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 02:32:56 -0500
Subject: Re: [PATCH] checkpatch.pl: remove the punch card limit
From: Stefani Seibold <stefani@seibold.net>
To: Miles Bader <miles@gnu.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
       jschopp@austin.ibm.com, davej@redhat.com
In-Reply-To: <buopr5mobn7.fsf@dhlpc061.dev.necel.com>
References: <1262796984.1011.17.camel@wall-e>
	 <buopr5mobn7.fsf@dhlpc061.dev.necel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 07 Jan 2010 08:31:58 +0100
Message-ID: <1262849518.13621.2.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 07.01.2010, 12:07 +0900 schrieb Miles Bader:
> Stefani Seibold <stefani@seibold.net> writes:
> > The time of 80 characters punch card and terminals are over, so i would
> > be a good thing to set the line length limit to 120. Every display today
> > should be able handle this. And it think it make formated source code
> > more readable.
> 
> Anyway, I think the vague consensus seems to be that it's OK to go over
> 80 chars in many cases, but that it may be an indicator that some
> refactoring is in order....

That's why i didn't removed the check. 120 character should be good, it
should be not an indicator for refactoring. Especial with tab width of
8.

Stefani


