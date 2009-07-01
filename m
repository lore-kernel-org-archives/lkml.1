Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbZGAJJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbZGAJJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 05:09:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbZGAJI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 05:08:58 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:40172 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbZGAJI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 05:08:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=o2EuxgcfibgOHno2sb+bIEkQS5ix9kbyENEPXfC4U9j6V/5Rw9i1MBP2twNucmuXkY
         eIZqbNE4fCmfDKjiMH3LDtpcSuyk1YTiASzVOX8bPOjkXK8nnGgJs76NPxO/nBBekkA9
         B2a3FlBRhvghhbE29VrRnCy4rHSYshpv1fFvs=
MIME-Version: 1.0
Date: Wed, 1 Jul 2009 17:08:54 +0800
Message-ID: <6e25f4cc0907010208g36df22eby18adec65d8d8bde@mail.gmail.com>
Subject: Build a static library for KOs
From: Dafu <maillist.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

As we know, a module could be build easily by kernel build system and
a simple Makefile. I wonder whether there is a way to build a static
library, saying, "*.a" for other drivers to link to.

Does kernel's build system support this feature? If yes, how to link
to this *.a by Makfile of a driver?

Thanks,
    Dafu
