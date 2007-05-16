Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbXEPRfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbXEPRfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 13:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbXEPRe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 13:34:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753AbXEPRez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 13:34:55 -0400
Message-ID: <464B4093.8090107@redhat.com>
Date: Wed, 16 May 2007 13:34:11 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] AFS: Implement shared-writable mmap
References: <20070515155224.29345.22719.stgit@warthog.cambridge.redhat.com> <20070515155231.29345.6212.stgit@warthog.cambridge.redhat.com> <20070515144007.f87d9be5.akpm@linux-foundation.org> <464A533B.8040507@yahoo.com.au> <Pine.LNX.4.64.0705161711090.7914@blonde.wat.veritas.com> <464B3BE4.10704@yahoo.com.au> <Pine.LNX.4.64.0705161823550.16760@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0705161823550.16760@blonde.wat.veritas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Thu, 17 May 2007, Nick Piggin wrote:
>> ... and I don't want to change the
>> VM in a way that people are not unhappy with :)
> 
> I'm hoping you intended one less negative ;)

Or one more...
