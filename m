Return-Path: <linux-kernel-owner+w=401wt.eu-S1759673AbZEZXhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673AbZEZXhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758135AbZEZXha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:37:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:15508 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbZEZXh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:37:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=SEeNWSE7LxWGfZpk3hZpDPXgX91artkYp4fIicGzUNDxUGeYew9S8w+5oeRWtW8HOl
         GIUB3AY9mVgxGlR2PHG31BBcZ5PwrdJhSzGWL3ZXIP0EmvPjtT4SyrzPZdKnfrMpjlOm
         AcsJy1eVVzhdjN+LpmBDH1/Gp32vInwhELFbk=
MIME-Version: 1.0
Date: Tue, 26 May 2009 16:37:29 -0700
X-Google-Sender-Auth: 8bba66d48cf1c058
Message-ID: <79e41e9f0905261637i568506bej14d12f3e5bf2433a@mail.gmail.com>
Subject: research questionnaire about kernel developers
From: Philip Guo <pg@cs.stanford.edu>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SUMMARY: This is a request to provide insights on 11 quantitative
findings about kernel developers to assist a grad student's research
project.  It will take around 10 to 20 minutes to respond.

---

INTRODUCTION: I am performing an empirical study on the roles of
developers in the Linux kernel project.  I have run some quantitative
analyses on Git data, which resulted in 11 distinct findings (shown
below).  I would like your help in interpreting the significance of
each, in order to strengthen my research paper.  I can send you the
raw data if necessary.

I would appreciate it if you could fill out this questionnaire
(as much as you have time for) and send it as an email reply to me.
Thanks again to everyone who responded to a similar questionnaire I
sent last year.

Philip Guo
Stanford University

---

FINDINGS: Please state why you think each is true (or not) based upon
your own experiences, intuitions, opinions, or personal anecdotes.

I will use the term 'prolific developers' to refer collectively to the
50 people who have written the most Linux kernel patches (1% of ~5,000
total developers).  I will refer to all others as 'normal developers'.

1. Prolific developers write larger patches than normal developers
(with each patch modifying more lines and files)

2. Prolific developers focus more on files that have more patches

3. Normal developers write relatively more patches that add new
features (when compared with prolific developers)

4. Normal developers write relatively more bugfix patches

5. Prolific developers write relatively more refactoring and code
clean-up patches (when compared with normal developers)

6. Prolific developers write relatively more patches that revert
changes made in previous patches

7. Developers who are new to Linux write patches and have other people
commit them to Git, but as they gain more experience writing patches,
they begin to also do commits

8. As time progresses, normal developers are writing more and more
patches (when compared with prolific developers)

9. As time progresses, the numbers of patch writers and committers
both increase, but the number of patch writers grows faster than the
number of committers

10. As time progresses, fewer patches are being committed by the same
developer who wrote the patch

11. As time progresses, it's taking longer to get a patch committed
after it's first written
