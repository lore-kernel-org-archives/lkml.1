Return-Path: <linux-kernel-owner+w=401wt.eu-S1756420AbZJ0THb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbZJ0THb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755786AbZJ0THa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:07:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:12285 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbZJ0THa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:07:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LpU6X6fy2LoUcnuBMIEZfRowUHHwXmsNCwB+2MmCTrk/hWAEZ3xO2prvScpbErwRRy
         TYtwpYad9QJui+R84QeBlXcszM2/lJeKzxM44rXsvsGFtcn3OGFBCZ59jAx3jMisB7Cx
         VgpuWk2mQYJ/tlgG5vm6rJGrYepZOHqPve6mk=
Message-ID: <4AE744F6.5050801@gmail.com>
Date: Tue, 27 Oct 2009 12:07:34 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PANIC: early exception 08 rip 246:10 error ffffffff810251b5 cr2
 0
References: <4AE24009.4090408@gmail.com> <dd18b0c30910261134s76274dbbj9c1904e78c2b5a38@mail.gmail.com> <21504.1256588976@turing-police.cc.vt.edu>            <4AE611B2.1030409@gmail.com> <29209.1256624599@turing-police.cc.vt.edu>
In-Reply-To: <29209.1256624599@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My bad I just realized with your printk's I forgot
again to add the curly's(those little things are
hard to see).

The results are similar with the messages, except
with the curly's the system will panic the same as above
and not boot.
(So I guess it was good to forget the curly's
to some extent).

Justin P. mattock

