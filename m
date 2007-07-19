Return-Path: <linux-kernel-owner+w=401wt.eu-S937256AbXGSNCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937256AbXGSNCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935902AbXGSNCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:02:07 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:50155 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936908AbXGSNCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:02:05 -0400
Date: Thu, 19 Jul 2007 09:01:59 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Jim Kovaric <jkovaric@us.ibm.com>
cc: "Serge E. Hallyn" <serge@hallyn.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Christian Ehrhardt <lk@c--e.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, serue@linux.vnet.ibm.com
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
In-Reply-To: <OF54A17BCF.9A1D7004-ON8725731D.0044828E-8625731D.0046CAED@us.ibm.com>
Message-ID: <Line.LNX.4.64.0707190901200.4393@d.namei>
References: <OF54A17BCF.9A1D7004-ON8725731D.0044828E-8625731D.0046CAED@us.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007, Jim Kovaric wrote:

> IBMs  TAMOS (Tivoli Access Manager for Operating systems) contains a 
> loadable module,
>  which is an "out of tree module",  and registers "itself"  as a security 
> module during the TAMOS startup
> process. It also requires that SElinux  be "disabled"

Please provide a link to the source code, so we can understand how you're 
using the API.



- James
-- 
James Morris
<jmorris@namei.org>
