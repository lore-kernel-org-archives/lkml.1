Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbZLBMRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbZLBMRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 07:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZLBMRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 07:17:00 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60582 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbZLBMQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 07:16:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=U8EbhdEpUjMNiXVvTWorR20iurAnKZqrdE9YwjOlHWgvUkfDf9K6KJ62Ze9+wTJEAO
         7ZN4VNlBIEMtI7Mh0nuetncfUv0bAn5TaZWL9VawKZF6XDPUce4iT+DKonYIWjn6giPW
         XpZoGyJptsMwMsjjtQ5JSZHbwzWU86PCRLctU=
MIME-Version: 1.0
Date: Wed, 2 Dec 2009 14:17:05 +0200
Message-ID: <2cd4ff050912020417r27b52a89v4e676c7d4ab74ad4@mail.gmail.com>
Subject: Inter Thread Coomunication
From: Mai Daftedar <mai.daftedar@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
   I have a question to ask I have two threads that have
messages(Structure with data) that should be passed between them.
After some googling I learnt that using queues and pipes are expensive
(effieciency wise) and that I should just pass in the parameters and
use mutex to protect shared data...
Can anyone add on to this tradeoff information

Note: Can you CC me in the reply


Thanks
Best Regards
Mai
