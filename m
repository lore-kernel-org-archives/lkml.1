Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbZJJHSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbZJJHSq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 03:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754774AbZJJHSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 03:18:46 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:63826 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbZJJHSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 03:18:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=q/Z6THwxJ1vYWJYn5RbnVWv8KfywSCpKpC1bniADOsJZDpsQ4DjYzLbJ7S/irMlDj8
         5XCeKNGT0k0gW36Ck3NZBkwFq9AJ3HMBOKLXTGj2SwcUIiLQpHJjGH0eeJUSxY7Uzopt
         Lpbl7++1k1Kz1YWGxSD/O7DlqKXKDfBxYIm7U=
MIME-Version: 1.0
In-Reply-To: <27a8ee1b0910100017h75579306i42463e309bd26712@mail.gmail.com>
References: <27a8ee1b0910100017h75579306i42463e309bd26712@mail.gmail.com>
Date: Sat, 10 Oct 2009 12:48:09 +0530
Message-ID: <27a8ee1b0910100018g1207c5b1uf742677b55f2f99b@mail.gmail.com>
Subject: How to add scheduler
From: Pankaj Parakh <me.pankajparakh@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi all,

 I want to add my scheduler in linux 2.6.25.3, which have modular
design, is there any document which can explain that modular design of
generic scheduler in detail. I wanted to try my scheduler.

Any guidance..



--
Pankaj Parakh
