Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbZJTTNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbZJTTNa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 15:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZJTTNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 15:13:30 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:34257 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbZJTTN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 15:13:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=ecU+Wqik/9XYldHUJ+5t3vwMggzjCibYfXxL8l4++3g5VdFAqWIAl1dMZLXK4D0kos
         2q52XHPqQGEkXx9oq+b/l7svUz706oQiKbSdEBYM9r4PG7j0BguUXmnfTE+FjZuyif7b
         ik6UjtuSC1sYFM0N5xOP9Eot3fP9cpA156H7g=
MIME-Version: 1.0
Date: Wed, 21 Oct 2009 00:37:36 +0530
Message-ID: <f22d86810910201207l43ac2461k50da90fc5ab70ff3@mail.gmail.com>
Subject: Why sys_gettid() is in timer.c?
From: "Leonidas ." <leonidas137@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shouldn't this be part of sched.c or some other relevantly  named file?

-Leo.
