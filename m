Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZBFU0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZBFU0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 15:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbZBFU03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 15:26:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56541 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbZBFU02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 15:26:28 -0500
Date: Fri, 6 Feb 2009 12:25:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, kirill@shutemov.name
Subject: Re: [PATCH 2/3] binfmt_script: rewrite using parse_shell_args()
Message-Id: <20090206122556.00290967.akpm@linux-foundation.org>
In-Reply-To: <1233866864-14422-2-git-send-email-kirill@shutemov.name>
References: <1233866864-14422-1-git-send-email-kirill@shutemov.name>
	<1233866864-14422-2-git-send-email-kirill@shutemov.name>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Feb 2009 22:47:43 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> parse_shell_args() allows to use more than one argument in shebang

What is the benefit in all of this?  Why should we merge it??
