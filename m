Return-Path: <linux-kernel-owner+w=401wt.eu-S1758181AbZJFTtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181AbZJFTtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 15:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757376AbZJFTtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 15:49:46 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:46074 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291AbZJFTtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 15:49:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=HCcXC3H3j8md7QLRAzALfkzppOWgUoe7TCnyZocqEBIohgSGfIPqUZcUDu46z0frls
         aYo2vhOErdtf9OCqc5wBNL5kbjb613N4MczFvnzzbWQ86rkj/wQs06ohd/enYdUwE3k4
         Sr1kRzHF4MSzJ025VxNqBLKCkI45XkG/eCV9E=
MIME-Version: 1.0
From: David Nicol <davidnicol@gmail.com>
Date: Tue, 6 Oct 2009 14:48:49 -0500
Message-ID: <934f64a20910061248r7f262410w3adcb0b344e1ef58@mail.gmail.com>
Subject: sqlite uses B+trees, doesn't it?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently read an exciting introductory article about btrfs

I understand that SQLite uses btrees of some kind, possibly b+trees like btrfs

It seems that there is a opportunity for awesomeness here.
