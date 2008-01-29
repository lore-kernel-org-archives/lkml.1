Return-Path: <linux-kernel-owner+w=401wt.eu-S1762047AbYA2CsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762047AbYA2CsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 21:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYA2CsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 21:48:14 -0500
Received: from namei.org ([69.55.235.186]:47363 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753226AbYA2CsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 21:48:13 -0500
Date: Tue, 29 Jan 2008 13:48:09 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Matt LaPlante <kernel1@cyberdogtech.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: "Default Linux Capabilities" default in 2.6.24
In-Reply-To: <20080128201041.e0ac76d5.kernel1@cyberdogtech.com>
Message-ID: <Xine.LNX.4.64.0801291347460.29383@us.intercode.com.au>
References: <20080124191201.324cf1a0.kernel1@cyberdogtech.com>
 <20080128201041.e0ac76d5.kernel1@cyberdogtech.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jan 2008, Matt LaPlante wrote:

> On Thu, 24 Jan 2008 19:12:01 -0600
> Matt LaPlante <kernel1@cyberdogtech.com> wrote:
> 
> > 
> > I'm doing a make oldconfig with the new 2.6.24 kernel.  I came to the prompt for "Default Linux Capabilities" which defaults to No:
> > 
> > ---
> >  Default Linux Capabilities (SECURITY_CAPABILITIES) [N/y/?] (NEW) ?
> > ---
> > 
> > However the help text recommends saying Yes.
> > 
> > ---
> >  This enables the "default" Linux capabilities functionality.
> >  If you are unsure how to answer this question, answer Y.
> > ---
> > 
> > Does this seem incongruous?  Also, what's the "question"? :)
> > 
> > Thanks, 
> > Matt LaPlante
> 
> Anyone?

I think this should be default y.


-- 
James Morris
<jmorris@namei.org>
