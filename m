Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbYIRL2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbYIRL2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 07:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYIRL2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 07:28:33 -0400
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:38933 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626AbYIRL2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 07:28:32 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: change TOS explicitly for egress packets on specified network interface
To: gshan <gshan@alcatel-lucent.com>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Thu, 18 Sep 2008 13:37:17 +0200
References: <bdkyY-4ZN-13@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KgHoz-0001GM-Pa@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gshan <gshan@alcatel-lucent.com> wrote:

> Hi All,
> 
> I want to control TOS for egress packets of specified network interface,
> so I introduced "unsigned long tos" to
> struct net_device::priv and it could be set through ioctl interface of
> ethernet driver.

http://www.linuxtopia.org/Linux_Firewall_iptables/x4737.html

