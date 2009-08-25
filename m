Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbZHYHOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbZHYHOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 03:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbZHYHOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 03:14:05 -0400
Received: from mail-vw0-f172.google.com ([209.85.212.172]:40175 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbZHYHOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 03:14:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=fddLQHLu51D5URBMWTpR4fvD8UqSWbm728nQmZ+0Hz2qYPTcv81a4XRn/kbc1sNeBA
         D9RHXlFBw3jEKgUtHRK/r1LHS2TepGiOdaMgMYoQnOPhIXQmA/4T/rfXojNDbfmpsBYc
         kplZt6qVRK7YRSQGf+l4XaLaMnkqvS+FNqVrM=
MIME-Version: 1.0
Date: Tue, 25 Aug 2009 15:14:04 +0800
Message-ID: <30c949580908250014j35bda484y173cc96ccf5feb39@mail.gmail.com>
Subject: hi,
From: Bill Xie <bill790@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My harware is a mips-achitecture hand-hold device, runs 2.6.24.3 and qt.
when an application program  opened a 3.2M pdf file, the memory was
consuming continually, finally the "oom-killer" things happened, the
applicaton was killed,
 but the memory occupied by the application still can not be freed. Is
there some methods
to do with this situation?
