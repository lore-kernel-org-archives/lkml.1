Return-Path: <linux-kernel-owner+w=401wt.eu-S1761529AbYBZHvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761529AbYBZHvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761257AbYBZHuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:50:35 -0500
Received: from hu-out-0506.google.com ([72.14.214.229]:43308 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761189AbYBZHud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:50:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=VAKhjum0hP8CRIB+x7rFNxl5A0L9K6piYNpHHCITB9ec0z2FRItMCQ1kzMXgAiz20ruR1xqME8KIl3lDYAUvePtCy8daCugDjPT6c83N6U1kD4OZhodhJlZx96CnjRCgxr2mdTNSreHmjRnxBeOczNtR+RBoEnXpnvZKwc/oguc=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: ide-cd: trivial fixes
Date: Tue, 26 Feb 2008 08:49:52 +0100
Message-Id: <1204012194-4208-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here some trivial fixes that i wanted to get out the door.
