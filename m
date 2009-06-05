Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbZFEK7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbZFEK7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 06:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZFEK7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 06:59:30 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:59233 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZFEK7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 06:59:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=nWL2YLPKfqCcbnkOIwsCb+Thnn5Ia8l7WqxG1IQCBAaP9ontDbXprr2HScT3infC0U
         BkAnqbTfZ+8jNfDzVuewOaaPzvNXHIme6u30OCSFyNo6B5uUcC8cAnpNzlkceX2HsjxS
         n8v4Ih2bxzL8haZH5ugT24jTdn8mkYuZ+NoHA=
MIME-Version: 1.0
Date: Fri, 5 Jun 2009 14:59:31 +0400
Message-ID: <f44001920906050359h5edc6782n69aa91472aae418f@mail.gmail.com>
Subject: Can kmalloc( ) with __GFP_WAIT flag fail?
From: Igor Zhbanov <izh1979@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Can kmalloc( ) fail when invoked with __GFP_WAIT flag (which is
implied by GFP_KERNEL)?
And for what reason it may fail?

Thanks.
