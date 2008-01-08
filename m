Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbYAHTY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbYAHTY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbYAHTYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:24:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52857 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbYAHTYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:24:46 -0500
Date: Tue, 8 Jan 2008 20:27:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Daniel Walker <dwalker@mvista.com>, Theodore Tso <tytso@mit.edu>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       apw@shadowen.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Deprecate checkpatch.pl --file
Message-ID: <20080108192713.GB1004@one.firstfloor.org>
References: <20080108161403.GA11632@basil.nowhere.org> <1199811033.1756.29.camel@imap.mvista.com> <20080108175347.GA25968@uranus.ravnborg.org> <1199815279.1756.35.camel@imap.mvista.com> <20080108182048.GM27800@mit.edu> <1199817208.1756.47.camel@imap.mvista.com> <20080108192142.GA26491@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108192142.GA26491@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But is discourage the creation of pure clean-up patches because it
> may have a disturbing effect on several other peoples work.

Exactly. Or rather it spells out when exactly pure cleanup patches are ok.

-Andi
