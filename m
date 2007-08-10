Return-Path: <linux-kernel-owner+w=401wt.eu-S936828AbXHJR1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936828AbXHJR1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 13:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934755AbXHJR0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 13:26:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:46476 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934120AbXHJR0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 13:26:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=HNtpwB2owsZfjgklz+IMng6tFRMce3Vt0t85R+bkEeh3+m4rbAUAero2J6GsS9Ogev+iYujHKXZ0DrnODhHAIwcFEPKXylcLHgNXFccvbfRNjkjzGgEHYRnhN3Cn/YtrxaYgIEmtQ3tgRuAvXev6jeaqxJVtUPuz0Tf9FanuuLk=
Message-ID: <a44ae5cd0708101026w61992976x10adfa62364d3bcf@mail.gmail.com>
Date: Fri, 10 Aug 2007 13:26:46 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       sct@redhat.com
Subject: 2.6.23-rc2-mm2 -- sysctl table check failed: /kernel/cad_pid .1.54 Missing strategy
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if these are important issues or not:

sysctl table check failed: /kernel/cad_pid .1.54 Missing strategy
sysctl table check failed: /kernel/pty/nr .1.62.2 No data
sysctl table check failed: /dev/parport/default/timeslice .7.3.-3.1
Missing strategy
sysctl table check failed: /dev/parport/default/spintime .7.3.-3.2
Missing strategy
