Return-Path: <linux-kernel-owner+w=401wt.eu-S1757713AbYIIUhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbYIIUhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 16:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYIIUhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 16:37:38 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:52912 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYIIUhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 16:37:37 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org
Subject: Re: [git pull] x86 fixes
Date: Tue, 9 Sep 2008 16:37:32 -0400
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>
References: <200809081932.m88JWVZG013061@askone.hos.anvin.org> <200809091518.16311.linux@sandersweb.net> <alpine.LFD.1.10.0809091255420.3117@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809091255420.3117@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091637.32650.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 15:56, Linus Torvalds wrote:
> On Tue, 9 Sep 2008, David Sanders wrote:
> > I haven't seen this come across the wire in Linus's 2.6.27 tree.  We're
> > still going to do this right?
>
> Latest version is out there now (leaving the gas-error-proofing for
> later),

The Kconfig.cpu change wasn't in my git pull.
David
