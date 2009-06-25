Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbZFYA0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbZFYA0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 20:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZFYA03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 20:26:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752682AbZFYA02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 20:26:28 -0400
Date: Wed, 24 Jun 2009 17:26:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, vapier@gentoo.org
Subject: Re: [PATCH] allow execve'ing "/proc/self/exe" even if /proc is not
  mounted
Message-Id: <20090624172602.f3afd25d.akpm@linux-foundation.org>
In-Reply-To: <1158166a0906241649u78c717c4q8aebfe16e6018e78@mail.gmail.com>
References: <1158166a0906241600w5f7f4ffcm49d9c849f0c27f72@mail.gmail.com>
	<20090624162125.a3a9b2c4.akpm@linux-foundation.org>
	<1158166a0906241649u78c717c4q8aebfe16e6018e78@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 01:49:13 +0200
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> Propose some other way to make it possible to re-execute a binary
> without /proc.

Add a system call to do this?


