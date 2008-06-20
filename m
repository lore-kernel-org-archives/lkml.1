Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbYFTDv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbYFTDv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 23:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYFTDvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 23:51:47 -0400
Received: from dahlia.cs.vt.edu ([128.173.236.198]:11876 "EHLO
	dahlia.cs.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbYFTDvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 23:51:46 -0400
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2008 23:51:46 EDT
Date: Thu, 19 Jun 2008 23:42:32 -0400
From: Bharath Ramesh <bramesh@vt.edu>
To: nicolas@boichat.ch
Cc: linux-kernel@vger.kernel.org
Subject: Apple SMC key enumeration
Message-ID: <20080620034232.GA15012@vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  I have new MacPro3 and I want to try to get the sensors on it working.
  I am trying to enumerate all the keys that Apple SMC allows. I used
  the key enumeration method you had mentioned in this thread

  http://lkml.org/lkml/2007/4/13/16

  But whenever I run any of the following:
  cat key_at_index_name
  cat key_at_index_type
  cat key_at_index_data_length

  I get the following error:
  cat: key_at_index_type: Input/output error
  cat: key_at_index_data_length: Input/output error
  hexdump: key_at_index_data: Input/output error

  Has the method to enumerate the keys changed? If it has whats the new
  way to enumerate the keys. Any help in this is appreciated.

Thanks,

Bharath

P.S I am not subscribed to the kernel mailing list, would appreciate if
you could CC me in the reply.

---
Bharath Ramesh       <bramesh@vt.edu>       http://people.cs.vt.edu/~bramesh

