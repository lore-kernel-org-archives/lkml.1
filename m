Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbYJLNxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbYJLNxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 09:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYJLNw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 09:52:59 -0400
Received: from 220-133-139-86.HINET-IP.hinet.net ([220.133.139.86]:53395 "EHLO
	cooldavid.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069AbYJLNw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 09:52:58 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Oct 2008 09:52:58 EDT
From: "Guo-Fu Tseng" <cooldavid@cooldavid.org>
To: "Steve French" <smfrench@gmail.com>, rjw@sisk.pl,
       "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>,
       jlayton@redhat.com, LKML <linux-kernel@vger.kernel.org>
Reply-To: cooldavid@cooldavid.org
Subject: Re: Fwd: [PATCH] Fix CIFS compilation with CONFIG_KEYS unset
Date: Sun, 12 Oct 2008 21:42:38 +0800
Message-Id: <20081012134204.M92371@cooldavid.org>
In-Reply-To: <524f69650810120640v41778375wf0a7662e773da26f@mail.gmail.com>
References: <200810121315.37203.rjw@sisk.pl> <524f69650810120640v41778375wf0a7662e773da26f@mail.gmail.com>
X-Mailer: Open WebMail 2.51 20050228
X-OriginatingIP: 140.117.194.21 (cooldavid)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2008 08:40:39 -0500, Steve French wrote
> Rafael and Guo-Fu,
> The following change to address the compile error that you noted is
> slightly different than what you suggested but should fix what you
> found.
Thank you for the fix. :)

Guo-Fu Tseng

