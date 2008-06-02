Return-Path: <linux-kernel-owner+w=401wt.eu-S1756784AbYFBBGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784AbYFBBGq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 21:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756352AbYFBBGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 21:06:34 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:42171 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133AbYFBBGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 21:06:33 -0400
Date: Sun, 1 Jun 2008 21:05:46 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Thorsten Knabe <linux@thorsten-knabe.de>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux 2.6.25.4 task_struct leak
Message-ID: <20080602010546.GA8578@c2.user-mode-linux.org>
References: <483EC624.90503@thorsten-knabe.de> <20080601213134.GJ4018@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080601213134.GJ4018@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 02:31:39PM -0700, Chris Wright wrote:
> * Thorsten Knabe (linux@thorsten-knabe.de) wrote:
> > [5.] Most recent kernel version which did not have the bug:
> > 2.6.23.17 does not leak task_structs.
> > 2.6.24 - 2.6.25.3 has not been tested

Has this been seen on non-UML?

    	      	   Jeff

-- 
Work email - jdike at linux dot intel dot com
