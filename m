Return-Path: <linux-kernel-owner+w=401wt.eu-S1760346AbYA3X3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760346AbYA3X3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 18:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbYA3X3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 18:29:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58600 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753971AbYA3X3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 18:29:24 -0500
Date: Wed, 30 Jan 2008 15:29:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm] Remove deprecation of a.out ELF interpreters
Message-Id: <20080130152915.6e7d5865.akpm@linux-foundation.org>
In-Reply-To: <20080130084041.GA8429@basil.nowhere.org>
References: <20080130084041.GA8429@basil.nowhere.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 09:40:41 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> 
> Andrew has already queued the patch to remove the support for a.out
> ELF interpreters. So remove the deprecation with it too.
> 

I'm trying to find which patch I might have queued which did this and came
up blank. 
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch is
the only relevant one.

You have such a patch in your tree but afaict that will just wreck David's
patch.

Confused.
