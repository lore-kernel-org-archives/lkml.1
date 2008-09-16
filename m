Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbYIPOj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbYIPOj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYIPOju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:39:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:27893 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYIPOjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:39:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Ge2BB5rUdaODCpZxmEJD1hy0HiUCHE0SMfcKT2fUs6IyXEy13H2zqipJ0et23vMero
         UKoWJNTysO8RjWJNxeKhdPjJIvoC72etBXjr6e78GCgiv+6Ue43tsjQ1PIFUVvGRX8Cz
         F1lXraNdwGuKCuE0PDU2qw1UzxsBNtaFIatHg=
Message-ID: <1f276abf0809160739r6e2f42b3j8941730136365fb9@mail.gmail.com>
Date: Tue, 16 Sep 2008 16:39:47 +0200
From: "Jacek Poplawski" <jacekpoplawski@gmail.com>
To: "John Stoffel" <john@stoffel.org>, linux-kernel@vger.kernel.org
Subject: Re: motherboard recommendations?
In-Reply-To: <18639.49959.895003.593644@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1f276abf0809160657x4264ad5dm74fd2689d804a7ad@mail.gmail.com>
	 <18639.49959.895003.593644@stoffel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2008 at 4:31 PM, John Stoffel <john@stoffel.org> wrote:
> Which ASUS board, the K8V?  If so, just look for a board with
> components that are known to work well with Linux.  Honestly, these
> days Linux supports alot more stuff right out of the box.

I was thinking the same few years ago, but on two Asus boards two had problems.
K8V-X SE is the board I have now, it's very bad choice for Linux, it
crashes very often when starting X (with DRI) - it's related to buggy
BIOS and AGP.
On another board SATA was supported after few months and there was
constant problem with network (there was long discussion about it on
LKML) - networking was working after boot but stops working after a
while. It was never fixed, so I don't use this board anymore.

-- 
Free Software - find interesting programs and change them
NetHack - meet interesting creatures, kill them and eat their bodies
Usenet - meet interesting people from all over the world and flame them
Decopter - unrealistic helicopter simulator, get it from http://decopter.sf.net
