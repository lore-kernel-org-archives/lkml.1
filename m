Return-Path: <linux-kernel-owner+w=401wt.eu-S1756372AbZELTHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372AbZELTHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 15:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbZELTHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 15:07:34 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:58186 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbZELTHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 15:07:33 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 12 May 2009 12:02:30 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: kvm@vger.kernel.org, viro@ZenIV.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH v7 1/3] eventfd: export eventfd interfaces for module
 use
In-Reply-To: <20090512182650.26131.21334.stgit@dev.haskins.net>
Message-ID: <alpine.DEB.1.10.0905121202020.29869@makko.or.mcafeemobile.com>
References: <20090512181134.26131.10023.stgit@dev.haskins.net> <20090512182650.26131.21334.stgit@dev.haskins.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009, Gregory Haskins wrote:

> We want to use eventfd from KVM which can be compiled as a module, so
> export the interfaces.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>

Acked-by: Davide Libenzi <davidel@xmailserver.org>



- Davide


