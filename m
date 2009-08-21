Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656AbZHUSLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbZHUSLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 14:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbZHUSLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 14:11:34 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:46191 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575AbZHUSLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 14:11:33 -0400
Date: Fri, 21 Aug 2009 20:11:33 +0200
Message-Id: <878604789@web.de>
MIME-Version: 1.0
From: Roland Kletzing <devzero@web.de>
To: linux-kernel@vger.kernel.org
Subject: FW: reiserfs bug with data=journal mount option
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/ne6R8BJ3Ix4DCNnMSoxNURBukb/disM9TrE7kCuaWkpgYO
 C043s6bDLP1FVLKy/36kguRPuOKiOzsGUMxQEYRVY5XpYr83Z0=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI:

http://bugzilla.kernel.org/show_bug.cgi?id=13556 - Random oopses
http://bugzilla.kernel.org/show_bug.cgi?id=13536 - crash while copying atime with touch
http://bugzilla.kernel.org/show_bug.cgi?id=13756 - Kernel panic occasionaly under load
http://bugzilla.kernel.org/show_bug.cgi?id=13876 - [x86_32, 2.6.30, reiserfs, reiser3, bug, regression] kernel oopsed while Sarg was running 
http://marc.info/?t=124680365400002&r=1&w=2 - Oops: Null pointer dereference in ReiserFS when under heavy load.

5 independent reports for probably the same bug!?

blocker for 2.6.31, imho.

regards
roland

(intentionally NOT cc`ing reiserfs-devel, as bugzilla mails already go there with no response....)

________________________________________________________________
Neu: WEB.DE Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://produkte.web.de/go/02/

