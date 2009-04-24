Return-Path: <linux-kernel-owner+w=401wt.eu-S1761273AbZDXRv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761273AbZDXRv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 13:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761023AbZDXRvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 13:51:01 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:43550 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761156AbZDXRu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 13:50:59 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 24 Apr 2009 10:47:14 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       avi@redhat.com
Subject: Re: [KVM PATCH v2 2/2] kvm: add support for irqfd via eventfd-notification
 interface
In-Reply-To: <49F1F1DD.7090101@novell.com>
Message-ID: <alpine.DEB.1.10.0904241046160.13603@makko.or.mcafeemobile.com>
References: <20090424042142.1796.60756.stgit@dev.haskins.net> <20090424042518.1796.65593.stgit@dev.haskins.net> <49F1F1DD.7090101@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Apr 2009, Gregory Haskins wrote:

> Hi David,
>    See inline for an answer to your last question:

Ok, so basically the eventfd lifetime is embedded inside the irqfd 
lifetime. Looks OK to me.



- Davide


