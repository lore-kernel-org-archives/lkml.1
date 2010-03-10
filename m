Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794Ab0CJV5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 16:57:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48570 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932769Ab0CJV5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 16:57:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] freezer: only show the state of tasks refusing to freeze
Date: Wed, 10 Mar 2010 23:00:19 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Xiaotian Feng <dfeng@redhat.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
References: <1268213322-5094-1-git-send-email-dfeng@redhat.com> <alpine.DEB.2.00.1003100252550.25220@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1003100252550.25220@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003102300.19497.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 March 2010, David Rientjes wrote:
> On Wed, 10 Mar 2010, Xiaotian Feng wrote:
> 
> > show_state will dump all tasks state, so if freezer failed to freeze
> > any task, kernel will dump all tasks state and flood the dmesg log.
> > This patch makes freezer only show state of tasks refusing to freeze.
> > 
> > Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> > Cc: Pavel Machek <pavel@ucw.cz>
> > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > Cc: Len Brown <len.brown@intel.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Alexey Dobriyan <adobriyan@gmail.com>
> > Cc: David Rientjes <rientjes@google.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>

Applied.

Rafael
