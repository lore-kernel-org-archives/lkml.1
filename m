Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbZAaAXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbZAaAXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 19:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbZAaAXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 19:23:30 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:59800 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZAaAXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 19:23:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=VifOAh2P2A1fSknTK0Oe7UHgKZN9FIL5yjeA02mjWqVrmW31EeYp5dWnWpNKQrbGc+
         T/zb4hNnpTbM8nNqUbAY5q1ehHw9tyHevDqus2BU8JrJgWc7Zs2Q44u/vjqQWhTMofZp
         WpWG2+LCvUJ6zTlH5QHVr2JGFW52EmM/3zeQk=
MIME-Version: 1.0
Date: Sat, 31 Jan 2009 01:23:28 +0100
Message-ID: <77887e110901301623u746535f2q7dcc37cd40d2cc56@mail.gmail.com>
Subject: libata - anomaly performance with NCQ
From: Bartosz SKOWRON <getxsick@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a problem:
http://ata.wiki.kernel.org/index.php/Known_issues#Seagate_harddrive_performance_anomaly_with_hdparm

and my disk is affected by this one as well.
it's ST9320421AS and you can add it to the list

And 2 questions:
1) cause the title contains "with hdparm"...does it mean that
physically the performance is OK and only hdparm shows something
wrong?
2) there is an information about upgrading firmware. as far as i know
Seagate doesn't publish firmwares. So the only way is to contact
seagate support, send the hdd and wait for the new one?

bart.
